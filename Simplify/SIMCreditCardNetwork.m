#import "SIMCreditCardNetwork.h"

@interface SIMCreditCardNetwork ()
@end

NSString *kSimplifyCommerceDefaultAPIBaseLiveUrl = @"https://sandbox.simplify.com/v1/api/";

@implementation SIMCreditCardNetwork

- (SIMCreditCardToken *)createCardTokenWithExpirationMonth:(NSString *)expirationMonth
											expirationYear:(NSString *)expirationYear
												cardNumber:(NSString *)cardNumber
													   cvc:(NSString *)cvc
													  name:(NSString *)name
											  addressLine1:(NSString *)addressLine1
											  addressLine2:(NSString *)addressLine2
													  city:(NSString *)city
													 state:(NSString *)state
													   zip:(NSString *)zip
													 error:(NSError **)error {
	NSString *publicKey = @"sbpb_OTY1YmI4N2UtYTJiOS00ZWUzLTliMGItZTFmYzQ2OTRmYmQ3";
	SIMCreditCardToken *cardToken = nil;
	
	NSURL *url = [[[NSURL alloc] initWithString:kSimplifyCommerceDefaultAPIBaseLiveUrl] URLByAppendingPathComponent:@"payment/cardToken"];
	// As GET, add parameters to URL
	NSMutableString *parameters = [NSMutableString stringWithFormat:@"?key=%@", [self urlEncoded:publicKey]];
	[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[number]"], cardNumber];
	[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[expMonth]"], expirationMonth];
	[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[expYear]"], expirationYear];
	[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[cvc]"], cvc];
	if (name.length) {
		[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[name]"], name];
	}
	if (addressLine1.length) {
		[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[addressLine1]"], addressLine1];
	}
	if (addressLine2.length) {
		[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[addressLine2]"], addressLine2];
	}
	if (city.length) {
		[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[addressCity]"], city];
	}
	if (state.length) {
		[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[addressState]"], state];
	}
	if (zip.length) {
		[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[addressZip]"], zip];
	}
	[parameters appendFormat:@"&%@=%@", [self urlEncoded:@"card[country]"], @"USA"];

	url = [NSURL URLWithString:[[url absoluteString] stringByAppendingString:parameters]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
	
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	// As GET, add parameters to URL
	request.HTTPMethod = @"GET";
	
	// As POST, add JSON to body
//	request.HTTPMethod = @"POST";
//	NSDictionary *requestJson = @{@"key" : publicKey,
//								@"card[number]" : cardNumber,
//								@"card[expMonth]" : expirationMonth,
//								@"card[expYear]" : expirationYear,
//								@"card[cvc]" : cvc,
//								@"card[name]" : @"John Doe",
//								};
//	request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestJson options:0 error:error];
	
	if (!*error) {
		NSHTTPURLResponse *response = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
		if (!*error) {
			if (response.statusCode >= 200 && response.statusCode < 300) {
				NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
				NSLog(@"json: %@", json);
				cardToken = [SIMCreditCardToken cardTokenFromDictionary:json];
			} else {
				NSLog(@"statusCode: %i", response.statusCode);
			}
		}
	}
	if (*error) {
		NSLog(@"%@", *error);
	}
	return cardToken;
}

- (NSString *)urlEncoded:(NSString *)value {
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) value, NULL,
                                                                                  (__bridge CFStringRef) @"!*'();:@&=+$,/?%#[]-.", kCFStringEncodingUTF8);
}

@end
