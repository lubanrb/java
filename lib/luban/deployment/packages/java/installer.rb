module Luban
  module Deployment
    module Packages
      class Java
        class Installer < Luban::Deployment::Service::Installer
          define_executable 'java'

          def package_dist; task.opts.dist; end
          def package_full_name; "jdk-#{package_major_version}-#{package_dist}"; end

          def source_repo
            @source_repo ||= 'http://download.oracle.com'
          end

          def source_url_root
            @source_url_root ||= "otn-pub/java/jdk/#{package_version}"
          end

          def jdk_version
            @jdk_version ||= "1.#{package_major_version.gsub('u', '.0_')}"
          end

          def installed?
            return false unless file?(java_executable)
            pattern = Regexp.new(Regexp.escape(jdk_version))
            match?("#{java_executable} -version 2>&1", pattern)
          end

          def build_path
            @build_path ||= package_tmp_path.join("jdk#{jdk_version}")
          end

          protected

          def download_package!
            unless test(:curl, "-j -k -L -H \"Cookie: oraclelicense=accept-securebackup-cookie\" -o #{src_file_path} #{download_url}")
              rm(src_file_path)
              abort_action('download')
            end
          end

          def build_package
            info "Building #{package_full_name}"
            within install_path do
              execute(:mv, build_path.join('*'), '.', ">> #{install_log_file_path} 2>&1")
            end
          end
        end
      end
    end
  end
end

