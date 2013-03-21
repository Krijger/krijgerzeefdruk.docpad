docpadConfig = {

	outPath: 'out'

	templateData:

		site:

			url: "http://www.krijgerzeefdruk.nl" + (@subDir ? '')

			oldUrls: [
			]

			# The default title of our website
			title: "Krijger Zeefdruk"

			# The website description (for SEO)
			description: """
				Krijger zeefdruk is een ambachtelijke zeefdrukkerij in Amsterdam Noord.
				Wij bieden hoge kwaliteit en ruime mogelijkheden met gebruik van vele materialen en inkten.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				zeefdruk, zeefdrukkerij, amsterdam, bedrukking, drukwerk, glas, plastic, kunst, speciaal, speciale, inkt, visitekaartjes
				"""

			# The website author's name
			author: "Quinten Krijger"

			# The website author's email
			email: "qkrijger@gmail.com"

		getUrl: (document) ->
			baseUrl = @subDir ? ''
			if typeof document is "string"
				baseUrl + document
			else
				baseUrl + (document.url or document.get?('url'))

		getUrls: (documents) ->
			(@getUrl(document) for document in documents)

		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	collections:
		# For instance, this one will fetch in all documents that have pageOrder set within their meta data
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		# This one, will fetch in all documents that have the tag "post" specified in their meta data
		posts: (database) ->
			database.findAllLive({tags: $has: ['post']}, [date:-1])


	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()

	environments:
		prodSim:
			outPath: 'out/docpad'
			templateData:
				subDir: '/docpad'

}

# Export our DocPad Configuration
module.exports = docpadConfig
