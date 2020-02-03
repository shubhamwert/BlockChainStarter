import utils.solcx_compiler as myCompiler
import json
if __name__ == "__main__":
    address='contracts\contracts.sol'
    files=[address]


    compiledFiles=myCompiler.compileContracts(files)
    print("compilation completed")
    with open('compiled_data.json','w') as savingLocation:
        # savingLocation.write(compiledFiles)
        json.dump(compiledFiles,savingLocation)