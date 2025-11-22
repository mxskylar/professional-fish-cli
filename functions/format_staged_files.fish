function format_staged_files	
	argparse 'c/cmd=' 'e/ext=+' -- $argv; or return
	if not set -q _flag_cmd
        	echo "Error: Paramenter -c/--cmd is required"
        	return 1
    	end
	set staged_files (git diff --name-only --cached)
	set files $staged_files
	if set -ql _flag_ext
		set files
		# Prefix all file extensions with period, if not prefixed already
		set file_extensions
		for ext in $_flag_ext
			if string match -q -- ".*" $ext
				set file_extensions $file_extensions $ext
			else
				set file_extensions $file_extensions ".$ext"
    			end
		end
		# Add files to list if they contain an extension in allow list
		for file in $staged_files
			for ext in $file_extensions
				if string match -q -- "*$ext" $file
					set files $files $file
					break
				end
			end
		end
	end	
	for file in $files 
		set format_command "$_flag_cmd $file"
		echo $format_command 
		eval $format_command
		git add "$file"
	end	
end
