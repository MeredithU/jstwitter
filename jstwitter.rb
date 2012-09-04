require 'jumpstart_auth'
require 'bitly'

class JSTwitter
	attr_reader :client

	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end


	def tweet(message)

		letter_count = message.length

		if letter_count <= 140
			@client.update(message)
		else
			puts "Your tweet is over 140 characters."	
		end
		
	end


	def run
		puts "Welcome to the JSL Twitter Client!"

		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]

			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(parts[1..-1].join(" "))
			when 'dm' then dm(parts[1], parts[2..-1].join(" "))
			when 'spam_my_followers' then spam_my_followers(parts[1..-1].join(" "))
			when 'elt' then everyones_profile_info
			when 's' then shorten(original_url)
			when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))	
			else
				puts "Sorry, I don't know how to (#{command})"
			end
		end
	end


	def dm(target, message)

		screen_names = @client.followers.collect{|follower| follower.screen_name}

		if screen_names.include?(target)
			dm_text = "d @#{target} #{message}"
			tweet(dm_text)
		else 
			puts "You can only DM people who follow you."
		end

	end


	def followers_list
		
		screen_names = []

		@client.followers.each do |follower| 
				screen_names << follower[:screen_name]
		end

		return screen_names

	end


	def spam_my_followers(message)

		all_followers = followers_list

		all_followers.each do |follower|
			dm(follower, message)
		end

	end


	def everyones_profile_info
		
		friends = @client.friends.sort_by{|friend| friend.screen_name.downcase}
		friends.each do |friend|
			
			user_screen_name = friend.screen_name # find each friends last message
			user_description = friend.description # print each friend's screen_name

			profile_created = friend.created_at
			timestamp = profile_created.strftime("%A, %b %d, %Y")
			
			puts "#{user_screen_name} created their profile on #{timestamp}..."
			puts "#{user_description}" # print each friend's description
			puts "" # Just print a blank line to separate people
		end
	end


	def shorten(original_url)

		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		new_url = bitly.shorten(original_url).short_url

		puts "Shortening this URL: #{original_url} and it creates this new url: #{new_url}"

		return new_url
	end

end



jst = JSTwitter.new
jst.run






