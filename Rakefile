require 'rake/testtask'

desc 'Reset DB'
task :dbreset do
  sh "dropdb camp_test &> null"
end

desc 'Create Test DB'
task :create_test_db do
  sh "createdb camp_test &> null"
  sh "psql -d camp_test < ./db/schema.sql &> null"
end

Rake::TestTask.new(name=:test_exec) do |t|
  t.libs << "test"
  t.test_files = FileList['test/controllers/*_test.rb']
  t.verbose = true
end

desc 'Reset DB and run tests'
task :test do
  Rake::Task[:dbreset].invoke
  Rake::Task[:create_test_db].invoke
  puts "Succesfully reset test database"

  Rake::Task[:test_exec].invoke
end



