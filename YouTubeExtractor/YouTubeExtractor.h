#import <Foundation/Foundation.h>

@interface YouTubeExtractor : NSObject
+ (NSDictionary *)youtubePlayerRequest :(NSString *)client :(NSString *)videoID;
@end