class AzureFunctionsCoreToolsAT4 < Formula
  funcVersion = "4.0.4385"
  if OS.linux?
    funcArch = "linux-x64"
    funcSha = "3e19ed04954f14e949f63535859c5369c285f7ba6a0cf8ddccc51d45cff1a253"
  elsif Hardware::CPU.arm?
    funcArch = "osx-arm64"
    funcSha = "520a79a29fdb5755f431fcaebf270802438d5dcfe6d9d1d220a6ca3688aac0ab"
  else
    funcArch = "osx-x64"
    funcSha = "57b45e9714a9c921a76ed745021b85283b15361084ca3e2dbc8df08b1a24fe52"
  end

  desc "Azure Functions Core Tools 4.0"
  homepage "https://docs.microsoft.com/azure/azure-functions/functions-run-local#run-azure-functions-core-tools"
  url "https://functionscdn.azureedge.net/public/#{funcVersion}/Azure.Functions.Cli.#{funcArch}.#{funcVersion}.zip"
  sha256 funcSha
  version funcVersion
  head "https://github.com/Azure/azure-functions-core-tools"


  @@telemetry = "\n Telemetry \n --------- \n The Azure Functions Core tools collect usage data in order to help us improve your experience." \
  + "\n The data is anonymous and doesn\'t include any user specific or personal information. The data is collected by Microsoft." \
  + "\n \n You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to \'1\' or \'true\' using your favorite shell.\n"

  def install
    prefix.install Dir["*"]
    chmod 0555, prefix/"func"
    chmod 0555, prefix/"gozip"
    bin.install_symlink prefix/"func"
    begin
      FileUtils.touch(prefix/"telemetryDefaultOn.sentinel")
      print @@telemetry
    rescue Exception
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/func")
    system bin/"func", "new", "-l", "C#", "-t", "HttpTrigger", "-n", "confusedDevTest"
    assert_predicate testpath/"confusedDevTest/function.json", :exist?
  end
end

