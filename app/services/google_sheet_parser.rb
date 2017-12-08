class GoogleSheetParser
	require 'google/apis/sheets_v4'
	require 'googleauth'
	require 'googleauth/stores/file_token_store'

	require 'fileutils'

	OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
	APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
	CLIENT_SECRETS_PATH = 'client_secret.json'
	CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
	                             "sheets.googleapis.com-ruby-quickstart.yaml")
	SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
	TIER_SHEET_ID = '1IKJeLNo-N3NcBf3VzDy0iVpt08LPNdQHPNwu5xLn4yE'

	def self.build_cards_and_tiers
		draft_ranking_groups.each do |tier_section|
			values_array = tier_section.values
			tier_name = values_array.first.first
			current_tier = Tier.where(name: tier_name).first_or_create
			values_array[1..-1].each do |card_name|
				Card.where(name: card_name.first).first_or_create(tier_id: current_tier.id)
			end
		end
	end

	private

	def self.draft_ranking_groups
		service = Google::Apis::SheetsV4::SheetsService.new
		service.client_options.application_name = APPLICATION_NAME
		service.authorization = authorize
		spreadsheet_id = TIER_SHEET_ID
		response = service.batch_get_spreadsheet_values(spreadsheet_id, ranges: range_names)
		response.value_ranges
	end

	def self.authorize
	  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
	  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
	  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
	  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
	  user_id = 'default'
	  credentials = authorizer.get_credentials(user_id)
	  if credentials.nil?
	    url = authorizer.get_authorization_url(
	      base_url: OOB_URI)
	    puts "Open the following URL in the browser and enter the " +
	         "resulting code after authorization"
	    puts url
	    code = gets
	    credentials = authorizer.get_and_store_credentials_from_code(
	      user_id: user_id, code: code, base_url: OOB_URI)
	  end
	  credentials
	end

	def self.range_names
		[
			'A3:A200',
			'C3:C200',
			'E3:E200',
			'G3:G200',
			'I3:I200',
			'K3:K200',
			'M3:M200',
			'Q3:Q200',
			'S3:S200',
			'U3:U200',
			'W3:W200'
    ]
	end
end