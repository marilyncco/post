time = Time.new
month = time.month
day = time.day
if (time.month < 10)
    month = "0#{month}"
end

if (day < 10)
    day = "0#{day}"
end

date = "#{time.year}-#{month}-#{day}"

Gem::Specification.new do |s|
    s.name        = 'post'
    s.license     = 'LGPL'
    s.executables << 'post'
    s.version     = '2.4.6'
    s.date        = date
    s.summary     = 'Package manager for Linux/Unix in pure ruby.'
    s.description = 'Post is a small, fast package manager for linux and unix systems based on principles of simplicity.'
    s.authors     = ['Thomas Chace']
    s.email       = 'tchacex@gmail.com'
    s.files       = ["lib/post.rb", "lib/plugins", "lib/plugins/http_fetch_binary.rb",
            "lib/plugins/install_binary.rb", "lib/plugins/verify_sha256.rb", "lib/plugins/remove_binary.rb",
            "lib/database.rb", "lib/buildtools.rb", "lib/plugins/fetch_source.rb", "lib/plugin.rb", "lib/plugins/depresolver.rb"]
    s.homepage    =
        'http://github.com/thomashc/Post'
end
