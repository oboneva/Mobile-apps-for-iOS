//
//  FileManager.m
//  MarxUp
//
//  Created by Ognyanka Boneva on 12.10.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "FileManager.h"

#define DEFAULT_IMAGE_NAME  @"Image"

@implementation FileManager

+ (NSArray<NSURL *> *)loadDocumentsOfType:(NSString *)type {
    NSArray<NSURL *> *defaultDocuments = [[NSBundle mainBundle] URLsForResourcesWithExtension:type subdirectory:nil];
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    [FileManager copyDefaultDocuments:defaultDocuments toDirectoryURL:documentsDirectoryURL];
    
    
    return [FileManager filteredContentOfDirectoryWithURL:documentsDirectoryURL withContentType:type];
}

+ (void)copyDefaultDocuments:(NSArray<NSURL *> *)ducumentURLs toDirectoryURL:(NSURL *)dirUrl {
    NSError *error = nil;
    
    for (NSURL *documentURL in ducumentURLs) {
        if (![FileManager fileWithURL:documentURL existInDirectoryWithURL:dirUrl]) {
            NSURL *destinationURL = [FileManager getURLOfFile:documentURL inDirectoryWithURL:dirUrl];
            [[NSFileManager defaultManager] copyItemAtURL:documentURL toURL:destinationURL error:&error];
        }
    }
}

+ (BOOL)fileWithURL:(NSURL *)fileURL existInDirectoryWithURL:(NSURL *)dirURL {
    NSURL *fileURLInDir = [self getURLOfFile:fileURL inDirectoryWithURL:dirURL];
    
    NSArray<NSURL *> *contentOfDir = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:dirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    
    for (NSURL *url in contentOfDir) {
        if ([url isEqual:fileURLInDir]) {
            return true;
        }
    }
    
    return false;
}

+ (NSURL *)getURLOfFile:(NSURL *)fileURL inDirectoryWithURL:(NSURL *)dirURL {
    NSString *fileName = [[[fileURL relativeString] componentsSeparatedByString:@"/"] lastObject];
    return [dirURL URLByAppendingPathComponent:fileName];
}

+ (NSArray<NSURL *> *)filteredContentOfDirectoryWithURL:(NSURL *)dirURL withContentType:(NSString *)type {
    NSArray<NSURL *> *content = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:dirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    return [content filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension = %@", type ]];
}

+ (void)copyURLToDocuments:(NSURL *)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *destinationURL = [FileManager getURLOfFile:url inDirectoryWithURL:documentsDirectoryURL];
    
    [fileManager copyItemAtURL:url toURL:destinationURL error:nil];
}

+ (void)saveImage:(NSData *)imageData atImageURL:(NSURL *)url {
    if (url) {
        [imageData writeToURL:url atomically:YES];
    }
    else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *imageName = [FileManager unusedNameInDirectory:documentsDirectoryURL];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:imageName];
        fileURL = [fileURL URLByAppendingPathExtension:@"png"];
        
        NSError *error = nil;
        [imageData writeToURL:fileURL options:NSDataWritingAtomic error:&error];
    }
}

+ (NSString *)unusedNameInDirectory:(NSURL *)dirURL {
    int number = 1;
    while ([FileManager isName:[NSString stringWithFormat:@"%@%d.png", DEFAULT_IMAGE_NAME, number]  alreadyUsedInDirectory:dirURL]) {
        number++;
    }
    
    return [NSString stringWithFormat:@"%@%d", DEFAULT_IMAGE_NAME, number];
}

+ (BOOL)isName:(NSString *)name alreadyUsedInDirectory:(NSURL *)dirURL { //fileManager.fileExists(atPath: path)
    NSArray<NSURL *> *content = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:dirURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    
    for(NSURL *fileURL in content) {
        if ([[fileURL.pathComponents lastObject] isEqualToString:name]) {
            return true;
        }
    }
    
    return false;
}

@end
