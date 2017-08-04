
namespace :profile do
  task :location => :environment do
    puts "profiles count: #{ Profile.count }"
    Profile.all.each do |p|
      puts "profile #{p.id}"
      p.send(:set_coordinates)
      p.save
    end
  end
end


