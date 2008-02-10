'#--
'# Copyright (c) 2006-2008 Luis Lavena, Multimedia systems
'#
'# This source code is released under the MIT License.
'# See MIT-LICENSE file for details
'#++

#include once "testly.bi"
#include once "test_helpers.bi"
#include once "simple_logger.bi"

namespace Suite_Test_Simple_Logger_Filename
    dim shared logger as SimpleLogger ptr
    
    sub before_each()
        logger = new SimpleLogger("testing.log")
    end sub
    
    sub after_each()
        delete logger
        assert_equal_error(0, kill("testing.log"))
    end sub

    sub test_create_with_filename()
        assert_string_equal("testing.log", logger->filename)
    end sub

    '# try logging DEBUG events when FATAL is the top
    sub test_logging_higher_level()
        dim content as string
        
        logger->level = SimpleLogger.Severity.FATAL
        
        '# logging a lower level than specified should return nothing
        logger->debug("a debug message")
        
        '# we need to release the file, still in buffer...
        logger->release
        
        content = content_of_file("testing.log")
        assert_equal(0, instr(content, "a debug message"))
    end sub
    
    sub test_logging_lower_level()
        dim content as string
        
        logger->level = SimpleLogger.Severity.FATAL
        
        '# now a valid level
        logger->fatal("a fatal error")
        '# we need to release the file, still in buffer...
        logger->release
        
        content = content_of_file("testing.log")
        assert_not_equal(0, instr(content, "a fatal error"))
    end sub

    private sub register() constructor
        add_suite(Suite_Test_Simple_Logger_Filename)
        add_test(test_create_with_filename)
        add_test(test_logging_higher_level)
        add_test(test_logging_lower_level)
    end sub
end namespace
