require 'spec_helper'

describe 'reaktor' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "reaktor class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('reaktor::params') }
          it { is_expected.to contain_class('reaktor::install').that_comes_before('reaktor::config') }
          it { is_expected.to contain_class('reaktor::config') }
          it { is_expected.to contain_class('reaktor::service').that_subscribes_to('reaktor::config') }

          it { is_expected.to contain_service('reaktor') }
          it { is_expected.to contain_package('reaktor').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'reaktor class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('reaktor') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
