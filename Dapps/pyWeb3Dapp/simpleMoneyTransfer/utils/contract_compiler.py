from solcx import compile_files,install_solc,set_solc_version

install_solc('v0.5.6')
set_solc_version('v0.5.6')
def compileContracts(files):

    return compile_files(files)

        