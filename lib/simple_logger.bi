'#--
'# Copyright (c) 2006-2007 Luis Lavena, Multimedia systems
'#
'# This source code is released under the MIT License.
'# See MIT-LICENSE file for details
'#++

#ifndef __SIMPLE_LOGGER_BI__
#define __SIMPLE_LOGGER_BI__

#include "boolean.bi"

#inclib "simple_logger"

type SimpleLogger
    declare constructor()
    declare constructor(byref as string)
    declare destructor()
    
    '# Severity Enum
    '# INFO < WARN < ERROR < FATAL < DEBUG
    enum Severity
        INFO
        WARN
        ERROR
        FATAL
        DEBUG
    end enum
    
    '# methods
    declare sub reopen(byref as string)
    declare sub release()
    
    '# logging methods
    declare sub info(byref as string)
    declare sub warn(byref as string)
    declare sub error(byref as string)
    declare sub fatal(byref as string)
    declare sub debug(byref as string)
    
    '# properties [RW]
    declare property level as Severity
    declare property level(byval as Severity)
    
    '# properties [RO]
    declare property is_open as boolean
    declare property filename as string
    
    private:
        '# by default log everything except DEBUG messages
        _level as Severity = Severity.FATAL
        _handle as integer
        _filename as string
        '# no file is open by default ;-)
        _is_open as boolean = false
        
        declare sub add_to_log(byval as Severity, byref as string)
end type

#endif '__SIMPLE_LOGGER_BI__
