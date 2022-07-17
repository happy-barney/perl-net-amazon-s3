#!perl

use strict;
use warnings;

use FindBin;

BEGIN { require "$FindBin::Bin/test-helper-operation.pl" }

expect_operation_buckets_list (
	"API" => \& api_buckets_list,
	"Client" => \& client_buckets_list,
);

had_no_warnings;

done_testing;

sub api_buckets_list {
	my (%args) = @_;

	build_default_api->buckets (%args);
}

sub client_buckets_list {
	my (%args) = @_;

	build_default_client->buckets (%args);
}

sub expect_operation_buckets_list {
	expect_operation_plan
		implementations => +{ @_ },
		expect_operation => 'Net::Amazon::S3::Operation::Buckets::List',
		expect_request_method => 'GET',
		expect_request_uri    => default_uri,
		expect_request_headers => {
			content_length => 0,
		},
		plan => {
			"list buckets" => {
				act_arguments => [
				],
			},
		}
}
