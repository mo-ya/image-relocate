#!/usr/bin/env ruby
# coding: utf-8
##
## Copyright (C) 2017 Y.Morikawa <http://moya-notes.blogspot.jp/>
##
## License: MIT License  (See LICENSE.md)
##
########################################
## Settings
########################################
DIR_FORMAT  = "%Y%m%d"
#DIR_FORMAT  = "%F"   # %F = %Y-%m-%d   (* Format of Time#strftime is available)

########################################
## Main
########################################

require 'fileutils'
require 'open3'
require 'time'
require 'pp'

class Dir
  def relocate!
    o, e, s = Open3.capture3("exiftool --ver")
    if !(s.success?)
      warn "ERROR: \"exiftool\" command is not found."
      exit 1
    end
    
    self.each do |file|
      # Exclude this script, directories, dot files
      if File.absolute_path(file) != File.absolute_path(__FILE__) and
        !( File.directory?(file) ) and
        file !~ /^\./

        exif_date_time_original = false
        
        # If exiftool command is available, try to inquire EXIF information
        o, e, s = Open3.capture3("exiftool \"#{file}\" | grep Date/Time")
        if s.success?
          o.split("\n").each{|info_line|
            if info_line =~ /^Date\/Time Original/
              label, time_str = info_line.split(":", 2)

              date, time = time_str.split(' ', 2)
              date.gsub!(/:/, '')
              exif_date_time_original = Time.parse("#{date} #{time}")
              break
            end
          }
          
          if !(exif_date_time_original)
            o.split("\n").each{|info_line|
              if info_line =~ /^File Modification Date\/Time/
                warn "[WARN] #{file}: \"Date/Time Original\" data in EXIF data not found. Use \"File Modification Date/Time\""

                label, time_str = info_line.split(":", 2)

                date, time = time_str.split(' ', 2)
                date.gsub!(/:/, '')
                exif_date_time_original = Time.parse("#{date} #{time}")
                break
              end
            }
          end
        end
        
        if !(exif_date_time_original)
          warn "[WARN] #{file}: \"Date/Time Original\", \"File Modification Date/Time\" data in EXIF data not found."
          next
        end

        # Create the destination directory
        dst_dir = exif_date_time_original.strftime(DIR_FORMAT)
        FileUtils.mkdir_p dst_dir, {:verbose => false}
        
        # Move photos
        dst_path = File.join(dst_dir, file)
        FileUtils.move file, dst_path, {:verbose => true}
      end
    end
  end
end

Dir.new(Dir.pwd).relocate!.close
