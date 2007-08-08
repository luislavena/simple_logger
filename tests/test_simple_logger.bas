'#--
'# Copyright (c) 2006-2007 Luis Lavena, Multimedia systems
'#
'# This source code is released under the MIT License.
'# See MIT-LICENSE file for details
'#++

#include once "testly.bi"
#include once "test_helpers.bi"
#include once "simple_logger.bi"

namespace Suite_Test_Simple_Logger
    dim shared logger as SimpleLogger ptr
    
    function setup() as boolean
        kill("testing.log")
        
        return true
    end function
    
    sub test_constant_values()
        assert_equal_error(0, Severity.DEBUG)
        assert_equal_error(1, Severity.INFO)
        assert_equal_error(2, Severity.WARN)
        assert_equal_error(3, Severity.ERROR)
        assert_equal_error(4, Severity.FATAL)
    end sub
    
    sub test_create()
        logger = new SimpleLogger()
        assert_not_equal_error(0, logger)
        assert_false(logger->is_open)
        assert_string_equal("", logger->filename)
        assert_equal(Severity.DEBUG, logger->level)
        delete logger
    end sub
    
    sub test_adjust_level()
        logger = new SimpleLogger()
        
        assert_equal(Severity.DEBUG, logger->level)
        logger->level = Severity.WARN
        assert_equal_error(Severity.WARN, logger->level)
    end sub
    
    sub test_create_with_filename()
        logger = new SimpleLogger("testing.log")
        
        assert_string_equal("testing.log", logger->filename)
        
        delete logger
    end sub
    
    sub test_reopen_filename()
        logger = new SimpleLogger()
        
        assert_string_equal("", logger->filename)
        assert_false(logger->is_open)
        
        logger->reopen("testing.log")
        
        assert_string_equal("testing.log", logger->filename)
        assert_true(logger->is_open)
        
        delete logger
    end sub
    
    sub test_logging_levels()
        dim content as string
        
        logger = new SimpleLogger("testing.log")
        logger->level = Severity.FATAL
        
        '# logging a lower level than specified should return nothing
        logger->debug("a debug message")
        
        content = content_of_file("testing.log")
        assert_equal(0, instr(content, "a debug message"))
        
        '# now a valid level
        logger->fatal("a fatal error")
        '# we need to release the file, still in buffer...
        logger->release
        
        content = content_of_file("testing.log")
        assert_not_equal(0, instr(content, "a fatal error"))
        
        delete logger
    end sub
    
    function teardown() as boolean
        assert_equal_error(0, kill("testing.log"))
        return true
    end function
    
    private sub register() constructor
        add_suite("Suite_Test_Simple_Logger", @setup, @teardown)
        add_test("test_constant_values", @test_constant_values)
        add_test("test_create", @test_create)
        add_test("test_adjust_level", @test_adjust_level)
        add_test("test_create_with_filename", @test_create_with_filename)
        add_test("test_reopen_filename", @test_reopen_filename)
        add_test("test_logging_levels", @test_logging_levels)
    end sub
end namespace
