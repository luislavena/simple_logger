'#--
'# Copyright (c) 2006-2007 Luis Lavena, Multimedia systems
'#
'# This source code is released under the MIT License.
'# See MIT-LICENSE file for details
'#++

#include once "simple_logger.bi"
#include once "string.bi"
#include once "datetime.bi"

'# By default, logger don't do anything
constructor SimpleLogger()
  '# default values where established using '= Value' in class definition
end constructor

constructor SimpleLogger(byref new_filename as string)
    '# TODO: call reopen
    '# reopen(new_filename)
    reopen(new_filename)
end constructor

destructor SimpleLogger()
    release
end destructor

property SimpleLogger.is_open() as boolean
    return _is_open
end property

property SimpleLogger.filename() as string
    return _filename
end property

property SimpleLogger.level() as Severity
    return _level
end property

property SimpleLogger.level(byval new_level as Severity)
    _level = new_level
end property

sub SimpleLogger.release()
    if (_is_open = true) then
        close #_handle
        _is_open = false
    end if
end sub

sub SimpleLogger.reopen(byref new_filename as string)
    if (_is_open = true) then
        '# release current file handler
        release
    end if
    
    _handle = freefile
    if (open(new_filename for append shared as #_handle) = 0) then
        _filename = new_filename
        _is_open = true
    end if
end sub

'# DRYied helpers :-)
#macro SUB_LOGGER(__SUB__, __LEVEL__)
sub SimpleLogger.__SUB__(byref message as string)
  add_to_log(Severity.__LEVEL__, message)
end sub
#endmacro

SUB_LOGGER(info, INFO)
SUB_LOGGER(warn, WARN)
SUB_LOGGER(error, ERROR)
SUB_LOGGER(fatal, FATAL)
SUB_LOGGER(debug, DEBUG)

sub SimpleLogger.add_to_log(byval message_level as Severity, _
                            byref message as string)
    
    dim level_text as string
    dim formatted_message as string
    
    '# only try if logging level is acceptable
    if (message_level <= _level) then
        select case message_level
            case Severity.DEBUG: level_text = "DEBUG"
            case Severity.INFO: level_text = "INFO"
            case Severity.WARN: level_text = "WARN"
            case Severity.ERROR: level_text = "ERROR"
            case Severity.FATAL: level_text = "FATAL"
            case else: level_text = "UNKNOWN"
        end select
        
        '# [2007-04-07 14:48:18] ERROR : TEST
        formatted_message = "[" + format(now, "yyyy-mm-dd hh:mm:ss") + "] " + _
                            level_text + " : " + message
                            
        '# write to file only if there is a file...
        if (_is_open = true) then
            print #_handle, formatted_message
        end if
    end if
end sub