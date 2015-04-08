/*  ilastik Launcher for Windows

    This file must reside in the ilastik root directory $ILASTIK_DIR
    and just launches 
       $ILASTIK_DIR/python/python.exe $ILASTIK_DIR/ilastik/ilastik/ilastik_launch.py args ...
       
    It clears $PYTHONPATH before starting python, so that we can be sure to have
    a clean ilastik installation.
*/

#include <windows.h>
#include <process.h>
#include <vector>
#include <string>
#include <iostream>
 
void printWinError(std::string message = "") 
{ 
    LPVOID lpMsgBuf;
    DWORD dw = GetLastError(); 

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        dw,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR) &lpMsgBuf,
        0, NULL );

    message += (char*)lpMsgBuf;
    LocalFree(lpMsgBuf);
    
    std::cerr << message << "\n";
}

int main(int argc, char **argv) 
{
    char buffer[2000];  /* the script's filename */
    GetModuleFileName(NULL, buffer, sizeof(buffer));
    
    // full name of this executable
    std::string this_exe(buffer);
    // we got something like 'path\bin\ilastik.exe' and extract the 'path' part
    std::string bin_path = this_exe.substr(0, this_exe.rfind("\\"));
    std::string path = bin_path.substr(0, bin_path.rfind("\\"));
    // create the paths to python and ilastik
    std::string script_name = path + "\\ilastik\\ilastik\\ilastik.py";
    std::string python_home = path + "\\python";
    std::string python_exe  = path + "\\python\\python.exe";
    
    std::vector<std::string> args;
    args.push_back("\"" + python_exe + "\"");
    args.push_back("\"" + script_name + "\"");
    args.push_back("\"--clean_paths\"");
    for(std::size_t k=1; k<argc; ++k)
        args.push_back(std::string("\"") + argv[k] + "\"");
    
    std::vector<const char *> cargs;
    for(std::size_t k=0; k<args.size(); ++k)
        cargs.push_back(args[k].c_str());
    cargs.push_back(0);
    
    SetEnvironmentVariable("PYTHONHOME", python_home.c_str());
    
    if(_spawnv(P_WAIT, python_exe.c_str(), &cargs[0]))
        printWinError("ilastik error: \n");
}

