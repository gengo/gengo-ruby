require 'spec_helper'
describe Gengo do

    context 'basic instantiation' do
        it 'should work' do
            lambda do
                @gengo_client = Gengo::API.new({
                                  :public_key => 'your_public_key',
                                  :private_key => 'your_private_key',
                                  :sandbox => true,
                                })
            end.should_not raise_error
        end
    end

    context 'endpoint checking' do

        it 'should have the right Sandbox url' do
            @gengo_client = Gengo::API.new({
                                  :public_key => 'your_public_key',
                                  :private_key => 'your_private_key',
                                  :sandbox => true,
                                })
            @gengo_client.api_host.should eq('api.sandbox.gengo.com')
        end

        it 'should have the right production url' do
            @gengo_client = Gengo::API.new({
                                  :public_key => 'your_public_key',
                                  :private_key => 'your_private_key',
                                  :sandbox => false,
                                })
            @gengo_client.api_host.should eq('api.gengo.com')
        end

    end

    context 'basic functions presence checks' do

        before(:each) do
            @gengo_client = Gengo::API.new({
                                  :public_key => 'your_public_key',
                                  :private_key => 'your_private_key',
                                  :sandbox => false,
                                })
        end

        # To be lazy, just add the symbol of the function name in this array ;)
        [
            :getAccountStats,
            :getAccountBalance,
            :getAccountPreferredTranslators,
            :postTranslationJobs,
            :updateTranslationJob,
            :updateTranslationJobs,
            :getTranslationJob,
            :getTranslationJobs,
            :getTranslationOrderJobs,
            :getTranslationQuote,
            :postTranslationJobComment,
            :getTranslationJobComments,
            :getTranslationJobFeedback,
            :getTranslationJobRevisions,
            :getTranslationJobRevision,
            :getTranslationJobPreviewImage,
            :deleteTranslationJob,
            :deleteTranslationJobs,
            :deleteTranslationOrder,
            :getServiceLanguagePairs,
            :getServiceLanguages,
            :getGlossaryList,
            :getGlossary,
            :getGlossaryFile
        ].each do |function|
            it "should respond to .#{function.to_s}" do
                @gengo_client.should respond_to(function)
            end
        end

    end
end
