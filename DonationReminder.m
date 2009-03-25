#import "DonationReminder.h"

@implementation DonationReminder

+ (void)goToDonation
{
	NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
	NSString *urlString = [bundleInfo objectForKey:@"DonationURL"];
	if (! urlString) {
		urlString = [[NSUserDefaults standardUserDefaults] stringForKey:@"DonationURL"];
	}
	NSAssert(urlString != nil, @"DonationURL is not specified.");
	
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)cancelDonation:(id)sender
{
	[[self window] close];
}

- (IBAction)donated:(id)sender
{
	NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *verList = [userDefaults objectForKey:@"DonatedVersions"];
	if (verList == nil) {
		verList = [NSArray arrayWithObject:[bundleInfo objectForKey:@"CFBundleVersion"]];
	}
	else {
		verList = [verList arrayByAddingObject:[bundleInfo objectForKey:@"CFBundleVersion"]];
	}
	[userDefaults setObject:verList forKey:@"DonatedVersions"];
}

- (IBAction)makeDonation:(id)sender
{
	[[self class] goToDonation];
	[[self window] close];
}

+ (id)displayReminder
{
	id newObj = [[self alloc] initWithWindowNibName:@"DonationReminder"];
	[newObj showWindow:newObj];
	return newObj;
}

+ (id)remindDonation
{
	//return [self displayReminder];
	NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *verList = [userDefaults objectForKey:@"DonatedVersions"];
	if (verList == nil) {
		return [self displayReminder];
	}
	else if (![verList containsObject:[bundleInfo objectForKey:@"CFBundleVersion"]]) {
		return [self displayReminder];
	}
	
	return nil;
}

- (NSString *)getProductName
{
	NSString *localizedStringKey = @"this software";
	NSString *productName = NSLocalizedString(localizedStringKey,@"");
	if ([productName isEqualToString:localizedStringKey]) {
		productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	}
	return productName;
}

- (void)awakeFromNib
{
	NSString *theMessage = [_productMessage stringValue];
	NSString *productName = [self getProductName];
	[_productMessage setStringValue: [NSString stringWithFormat:theMessage,productName]];
	[[self window] center];
}

@end
