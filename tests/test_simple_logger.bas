'#--
'# Copyright (c) 2006-2008 Luis Lavena, Multimedia systems
'#
'# This source code is released under the MIT License.
'# See MIT-LICENSE file for details
'#++

#include once "testly.bi"
#include once "test_helpers.bi"
#include once "simple_logger.bi"

namespace Suite_Test_Simple_Logger
    dim shared logger as SimpleLogger ptr
    
    sub before_each()
        logger = new SimpleLogger()
    end sub
    
    sub after_each()
        delete logger
    end sub
    
    sub test_constant_values()
        assert_equal_error(0, SimpleLogger.Severity.INFO)
        assert_equal_error(1, SimpleLogger.Severity.WARN)
        assert_equal_error(2, SimpleLogger.Severity.ERROR)
        assert_equal_error(3, SimpleLogger.Severity.FATAL)
        assert_equal_error(4, SimpleLogger.Severity.DEBUG)
    end sub

    sub test_create()
        assert_not_equal_error(0, logger)
        assert_false(logger->is_open)
        assert_string_equal("", logger->filename)
    end sub

    sub test_default_level()
        assert_equal(SimpleLogger.Severity.FATAL, logger->level)
    end sub

    sub test_adjust_level()
        assert_equal(SimpleLogger.Severity.FATAL, logger->level)
        logger->level = SimpleLogger.Severity.WARN
        assert_equal_error(SimpleLogger.Severity.WARN, logger->level)
    end sub
    
    sub test_reopen_filename()
        assert_string_equal("", logger->filename)
        assert_false(logger->is_open)
        
        logger->reopen("testing.log")
        
        assert_string_equal("testing.log", logger->filename)
        assert_true(logger->is_open)
    end sub
    
    private sub register() constructor
        add_suite(Suite_Test_Simple_Logger)
        add_test(test_constant_values)
        add_test(test_create)
        add_test(test_default_level)
        add_test(test_adjust_level)
        add_test(test_reopen_filename)
    end sub
end namespace
