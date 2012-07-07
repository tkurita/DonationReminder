#import "DonationReminder.h"


static DonationReminder *sharedDonationReminder = nil;

@implementation DonationReminder

+ (void)goToDonation
{
	NSDictionary *bundleInfo = [[NSBundle mainBundle] localizedInfoDictionary];
	NSString *urlString = [bundleInfo objectForKey:@"DonationURL"];
	if (! urlString) {
		bundleInfo = [[NSBundle mainBundle] infoDictionary];
		urlString = [bundleInfo objectForKey:@"DonationURL"];		
	} else if (! urlString) {
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

+ (id)sharedDonationReminder
{
	if (!sharedDonationReminder) {
		sharedDonationReminder = [[self alloc] initWithWindowNibName:@"DonationReminder"];
	}
	return sharedDonationReminder;
}

+ (BOOL)isWindowOpened
{
	BOOL result = NO;
	if (sharedDonationReminder) {
		result = [[sharedDonationReminder window] isVisible];
	}
	return result;
}

+ (id)displayReminder
{
	DonationReminder *a_reminder = [self sharedDonationReminder];
	[a_reminder showWindow:self];
	return a_reminder;
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
		productName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleName"];
		if (!productName) {
			productName = productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
		}
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
