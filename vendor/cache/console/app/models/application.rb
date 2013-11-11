require "#{Console::Engine.root.join('app', 'models', 'application')}"

class Application
  ['start', 'stop'].each do |action|
    class_eval <<-EOS
      def #{action}!
        self.messages.clear
        response = post(:events, nil, {:event => :#{action}}.to_json)
        self.messages = extract_messages(response)
        true
      end
    EOS
  end

  ['start', 'stop', 'restart', 'status'].each do |action|
    class_eval <<-EOS
      def #{action}_ide!
        self.messages.clear
        response = post(:events, nil, {:event => "#{action}-ide"}.to_json)
        self.messages = extract_messages(response)
        true
      end
    EOS
  end

  # Helper method to extract the name from an ID param containing the name as well
  def self.name_from_param(param)
    param.to_s.gsub(/.*-/, '') if param
  end
end