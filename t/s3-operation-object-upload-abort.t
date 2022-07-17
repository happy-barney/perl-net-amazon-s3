#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_object_upload_abort (
	'Client / named arguments'    => \& client_object_upload_abort_named_arguments,
	'Client / configuration hash' => \& client_object_upload_abort_configuration_hash,
);

had_no_warnings;

done_testing;

sub client_object_upload_abort_named_arguments {
	my (%args) = @_;

	build_default_client_object (%args)
		->abort_multipart_upload (%args)
		;
}

sub client_object_upload_abort_configuration_hash {
	my (%args) = @_;

	build_default_client_object (%args)
		->abort_multipart_upload (\ %args)
		;
}

sub expect_operation_object_upload_abort {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Object::Upload::Abort',
		expect_request_method => 'DELETE',
		expect_request_uri    => "https://bucket-name.${ \ default_hostname }/some-key?uploadId=42",
		plan => {
			"abort upload" => {
				act_arguments => [
					bucket      => 'bucket-name',
					key         => 'some-key',
					upload_id   => 42,
				],
				expect_request => methods (
					bucket      => expectation_bucket ('bucket-name'),
					key         => 'some-key',
					upload_id   => 42,
				),
				expect_request_headers => {
					content_length => 0,
				},
			},
		}
}

