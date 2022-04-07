Gem::Specification.new do |s|
  s.name = 'umap'
  s.version = '0.0.1'
  s.date = 04/07/22
  s.summary = "micro mapper web framework"
  s.authors = ["xxanon"]
  s.email = "ironald@gmail.com"
  s.files = `git ls-files`.split("\n") - %w[bin misc]
  s.executables += `git ls-files bin`.split("\n").map{|e| File.basename(e)}
  s.homepage = "https://github.com/nonnax/umap.git"
  s.license = "GPL-3.0"
end
