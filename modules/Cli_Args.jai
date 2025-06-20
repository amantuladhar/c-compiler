Cli_Args :: struct {
    src_path              : string;
    src_path_without_ext  : string;
    output_type           : Output_Type    = .EXE;
    flags                 : Cli_Args_Flags = .LEX | .PARSE | .SEMA | .TACKY | .CODE_GEN | .ALL;
}

Cli_Args_Flags :: enum_flags {
    LEX;
    PARSE;
    SEMA;
    TACKY;
    CODE_GEN;
    ALL;
}

get_cli_args :: () -> Cli_Args {
    args := get_command_line_arguments();
    args = array_view(args, 1);

    using cli_args := Cli_Args.{};

    for args {
        if it == {
            case "--lex";          flags = .LEX;
            case "--parse";        flags = .LEX | .PARSE;
            case "--validate";     flags = .LEX | .PARSE | .SEMA;
            case "--tacky";        flags = .LEX | .PARSE | .SEMA | .TACKY;
            case "--code-gen";     #through;
            case "--codegen";      flags = .LEX | .PARSE | .SEMA | .TACKY | .CODE_GEN; 
            case "-c";             output_type = .OBJ;
            case; src_path = it;
        }
    }
    if src_path == "" unreachable("No source file specified");
    if slice(src_path, src_path.count - 2, 2) != ".c" unreachable("Source file must have an .c extension");
    src_path_without_ext = slice(src_path, 0, src_path.count - 2);
    return cli_args;
}

#scope_module
#import "String";
#import "Compiler_Util";
#import "Basic";
#import "Not_Basic";
