RequireSupportFiles File.dirname(__FILE__) + "/../../../edit_view/features/"
RequireSupportFiles File.dirname(__FILE__) + "/../../../project/features/"
RequireSupportFiles File.dirname(__FILE__) + "/../../../html_view/features/"

def runnable_fixtures
  File.expand_path(File.dirname(__FILE__) + "/../fixtures")
end

def runnable_config
  "#{runnable_fixtures}/.redcar/runnables/fixture_runnables.json"
end

def reset_runnable_fixtures
  # Not sure why this is needed, perhaps next test is starting before full deletion?
  FileUtils.rm_rf runnable_fixtures
  FileUtils.mkdir runnable_fixtures
  FileUtils.mkdir_p File.dirname(runnable_config)
  
  File.open("#{runnable_fixtures}/runnable_app.rb", 'w') do |f|
    f.puts %Q|puts "hello world"|
  end
  
  File.open(runnable_config, 'w') do |f|
    f.print <<-EOS
      {
        "commands":[
          {
            "name":        "An app",
            "command":     "jruby runnable_app.rb",
            "description": "Runs the app",
            "type":        "task/ruby"
            },
          {
            "name":        "A silent app",
            "command":     "jruby runnable_app.rb",
            "description": "Runs the app silently",
            "type":        "task/ruby",
            "output":      "none"
          },
          {
            "name":        "A windowed app",
            "command":     "jruby runnable_app.rb",
            "description": "Runs the app in a window",
            "type":        "task/ruby",
            "output":      "window"
          }
        ],
        "file_runners":[
          {
            "regex":   ".*\\\\.rb",
            "name":    "Run as ruby",
            "command": "jruby \\"__PATH__\\"",
            "type":    "app/ruby"
          }
        ]
      }
    EOS
  end
end

Before do
  reset_runnable_fixtures
end

After do
  FileUtils.rm_rf runnable_fixtures
end