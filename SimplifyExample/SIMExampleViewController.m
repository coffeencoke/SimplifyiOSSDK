/* Copyright (c) 2013, Asynchrony Solutions, Inc.
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *
 *    * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 *    * Neither the name of Asynchrony Solutions, Inc. nor the
 *      names of its contributors may be used to endorse or promote products
 *      derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL ASYNCHRONY SOLUTIONS, INC. BE LIABLE FOR ANY
 *  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SIMExampleViewController.h"
#import "SIMCreditCardEntryViewController.h"
#import "SIMLayeredButton.h"
#import "SIMCreditCardTokenInformationView.h"

@interface SIMExampleViewController () <SIMCreditCardEntryViewControllerDelegate>
@property (nonatomic) SIMCreditCardEntryViewController *creditCardEntryViewController;
@property (nonatomic) SIMLayeredButton *showButton1;
@property (nonatomic) SIMLayeredButton *showButton2;
@property (nonatomic) SIMCreditCardTokenInformationView *infoView;
@property (nonatomic) NSString *publicApiToken;
@end

@implementation SIMExampleViewController

- (id)init {
    if (self = [super init]) {
	    self.publicApiToken = @"sbpb_OTY1YmI4N2UtYTJiOS00ZWUzLTliMGItZTFmYzQ2OTRmYmQ3";
    }
    return self;
}

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

	SIMLayeredButton* showButton1 = [[SIMLayeredButton alloc] init];
	[showButton1 setTitle:@"Show Card Form (No Address)" forState:UIControlStateNormal];
	showButton1.titleLabel.font = [UIFont systemFontOfSize:18.0f];
	showButton1.titleLabel.shadowColor = [UIColor blackColor];
	showButton1.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[showButton1 addTarget:self action:@selector(showButton1Tapped) forControlEvents:UIControlEventTouchUpInside];
	CGSize buttonSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 40.0, 40.0);
	showButton1.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - buttonSize.width / 2, 50.0, buttonSize.width, buttonSize.height);

	SIMLayeredButton* showButton2 = [[SIMLayeredButton alloc] init];
	[showButton2 setTitle:@"Show Card Form (With Address)" forState:UIControlStateNormal];
	showButton2.titleLabel.font = [UIFont systemFontOfSize:18.0f];
	showButton2.titleLabel.shadowColor = [UIColor blackColor];
	showButton2.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[showButton2 addTarget:self action:@selector(showButton2Tapped) forControlEvents:UIControlEventTouchUpInside];
	buttonSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 40.0, 40.0);
	showButton2.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - buttonSize.width / 2, CGRectGetMaxY(showButton1.frame) + 10.0, buttonSize.width, buttonSize.height);

	self.showButton1 = showButton1;
	self.showButton2 = showButton2;
	[self.view addSubview:showButton1];
	[self.view addSubview:showButton2];
}

- (void)showButton1Tapped {
	self.creditCardEntryViewController = [[SIMCreditCardEntryViewController alloc] initWithPublicApiToken:self.publicApiToken addressView:NO];
	self.creditCardEntryViewController.delegate = self;
	[self presentViewController:self.creditCardEntryViewController animated:YES completion:nil];
}

- (void)showButton2Tapped {
	self.creditCardEntryViewController = [[SIMCreditCardEntryViewController alloc] initWithPublicApiToken:self.publicApiToken addressView:YES];
	self.creditCardEntryViewController.delegate = self;
	[self presentViewController:self.creditCardEntryViewController animated:YES completion:nil];
}

#pragma mark - Private methods

- (void)dismissCreditCardEntryViewController {
	[self dismissViewControllerAnimated:YES completion:nil];
	self.creditCardEntryViewController = nil;

	if (self.infoView) {
		[self.infoView removeFromSuperview];
		self.infoView = nil;
	}
}

#pragma mark - SIMCreditCardEntryViewControllerDelegate methods

- (void)tokenGenerationCancelled {
	[self dismissCreditCardEntryViewController];
}

- (void)receivedCreditCardToken:(SIMCreditCardToken *)creditCardToken error:(NSError *)error {
	if (error) {
		NSLog(@"Error: %@", error);
	} else {
		NSLog(@"Token: %@", creditCardToken);
	}

	[self dismissCreditCardEntryViewController];

	CGFloat startY = CGRectGetMaxY(self.showButton2.frame) + 20.0;
	CGRect infoFrame = CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - startY);
	self.infoView = [[SIMCreditCardTokenInformationView alloc] initWithFrame:CGRectInset(infoFrame, 10.0, 0.0) creditCardToken:creditCardToken];
	self.infoView.backgroundColor = UIColor.clearColor;
	[self.view addSubview:self.infoView];
}

@end
