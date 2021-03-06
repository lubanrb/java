module Luban
  module Deployment
    module Packages
      class Java < Luban::Deployment::Package::Base
        def self.decompose_version(version)
          vers = version.split('-')
          { major_version: vers[0], patch_level: vers[1] }
        end

        protected

        def setup_provision_tasks
          super
          provision_tasks[:install].option :dist, "Binary distribution"
        end
      end
    end
  end
end
