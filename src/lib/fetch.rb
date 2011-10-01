# Copyright (C) Thomas Chace 2011 <ithomashc@gmail.com>
#
# This file is part of Post.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above
#   copyright notice, this list of conditions and the following disclaimer
#   in the documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require("rubygems")
require("fileutils")
require("xmlsimple")
require("net/http")

load(File.join(File.expand_path(File.dirname(__FILE__)), "tools.rb"))
load(File.join(File.expand_path(File.dirname(__FILE__)), "query.rb"))

class Fetch
    def initialize()
        if File.exists?("/tmp/post")
            FileUtils.rm_r("/tmp/post")
        end
        FileUtils.mkdir("/tmp/post")
        FileUtils.cd("/tmp/post")

        unless(@queue)
            @queue = []
        end
    end
    def buildQueue(package)
        if Query.getAvailable(package)
            if Query.getLatestVersion(package).to_i() > Query.getInstalledVersion(package).to_i()
                for dependency in Query.getDependencies(package)
                    buildQueue(dependency)
                end
                @queue.push(package)
            else
                puts("Latest version of #{package} installed.")
            end
        else
            puts("No package: '" + package + "' available.")
        end
    end
    def fetchPackages()
        for package in @queue
            url = Query.getUrl(package)
            filename = Query.getFileName(package)
            Tools.getFile(url, filename)
            installPackage(filename)
            initialize()
        end
    end
    def installPackage(filename)
        Tools.extract(filename)
        puts("Installing: " + filename)
        FileUtils.rm(filename)
        installedFiles = Dir["**/*"].reject {|fn| File.directory?(fn) }
        installedDirectories = Dir["**/*"].reject {|fn| File.file?(fn) }
        Query.addInstalledPackage("#{Dir.pwd()}/.packageData", "#{Dir.pwd()}/.install",
                                  "#{Dir.pwd()}/.remove", installedFiles)
        for directory in installedDirectories
           Tools.mkdir(directory)
        end
        for file in installedFiles
            Tools.installFile(file, file)
        end
        installScript = File.read(".install")
        eval(installScript)
    end
end
