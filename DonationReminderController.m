//
//  DonationReminderController.m
//  DonationReminder
//
//  Created by 栗田 哲郎 on 2016/09/28.
//
//

#import "DonationReminderController.h"
#import "DonationReminder.h"

@implementation DonationReminderController

- (void)awakeFromNib
{
    [DonationReminder remindDonation];
}

- (IBAction)makeDonation:(id)sender;
{
    [DonationReminder goToDonation];
}

@end
