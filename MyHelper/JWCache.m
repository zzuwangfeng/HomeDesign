//
//  JWCache.m
//  JWCache
//
//  Created by JaclWong on 6/28/12.
//  Copyright (c) 2012 JWCache. All rights reserved.
//

#import "JWCache.h"
#import <SDImageCache.h>

static NSTimeInterval cacheTime =  (double)604800;

@implementation JWCache

+ (void) resetCache {
	[[NSFileManager defaultManager] removeItemAtPath:[JWCache cacheDirectory] error:nil];
}

+ (NSString*) cacheDirectory {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"FTWCaches"];
	return cacheDirectory;
}

+ (CGFloat)getCacheLength {
    //缓存路径
    NSString *cachePath = [self cacheDirectory];
    //获取缓存大小。。
    CGFloat fileSize = [self folderSizeAtPath:cachePath];
    
    //获取缓存的大小
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
//    NSLog(@"%f", intg/ 1024.0 / 1024);
//    NSLog(@"%f", fileSize);
    return fileSize + intg / 1024 / 1024.0;
}



////计算出大小
//- (NSString *)fileSizeWithInterge:(NSInteger)size{
//    // 1k = 1024, 1m = 1024k
//    if (size < 1024) {// 小于1k
//        return [NSString stringWithFormat:@"%ldB",(long)size];
//    }else if (size < 1024 * 1024){// 小于1m
//        CGFloat aFloat = size/1024;
//        return [NSString stringWithFormat:@"%.0fK",aFloat];
//    }else if (size < 1024 * 1024 * 1024){// 小于1G
//        CGFloat aFloat = size/(1024 * 1024);
//        return [NSString stringWithFormat:@"%.1fM",aFloat];
//    }else{
//        CGFloat aFloat = size/(1024*1024*1024);
//        return [NSString stringWithFormat:@"%.1fG",aFloat];
//    }
//}

+ (CGFloat)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName = nil;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (NSData*) objectForKey:(NSString*)key {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
	
	if ([fileManager fileExistsAtPath:filename])
	{
		NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
		if ([modificationDate timeIntervalSinceNow] > cacheTime) {
			[fileManager removeItemAtPath:filename error:nil];
		} else {
			NSData *data = [NSData dataWithContentsOfFile:filename];
			return data;
		}
	}
	return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];

	BOOL isDir = YES;
	if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
		[fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	NSError *error;
	@try {
		[data writeToFile:filename options:NSDataWritingAtomic error:&error];
	}
	@catch (NSException * e) {
		//TODO: error handling maybe
	}
}


@end
