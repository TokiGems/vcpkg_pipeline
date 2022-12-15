PASSWORD=$1

gem build vcpkg_pipeline.gemspec -o vcpkg_pipeline.gem
echo "${PASSWORD}" | sudo -S gem install vcpkg_pipeline.gem
