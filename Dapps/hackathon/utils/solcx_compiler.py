from solcx import compile_files,install_solc,set_solc_version

install_solc('v0.5.15')
set_solc_version('v0.5.15')
def compileContracts(files):

    return compile_files(files)

        