long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
%w{ zsh git build-essential openssl xml zlib postgresql }.each do |cb_depend|
  depends cb_depend
end
%w{ debian ubuntu }.each do |os|
  supports os
end
