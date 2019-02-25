#import "RedditContactPhotoProvider.h"
#import <Foundation/Foundation.h>

@implementation RedditContactPhotoProvider

- (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
  NSString *username = [[[[[notification.applicationUserInfo valueForKeyPath:@"aps.alert.title"] componentsSeparatedByString:@"u/"] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
  if (!username) return nil;
  NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"https://www.reddit.com/user/%@/about.json",username]]];
  NSError* error;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
  if(error) { return nil; }
  NSString *photoURLStr = json[@"data"][@"icon_img"];
  NSURL *photoURL = [NSURL URLWithString:photoURLStr];
  if (!photoURL) return nil;
  return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerDownloadingPromiseWithPhotoIdentifier:photoURLStr fromURL:photoURL];
}

@end
