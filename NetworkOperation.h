//
//  NetworkOperation.h
//  BestSub
//
//  Created by Pan Wang on 14-8-23.
//  Copyright (c) 2014年 walz. All rights reserved.
//

#import <Foundation/Foundation.h>



enum NetworkOperationMode {
    getMode,
    postMode
};
typedef enum NetworkOperationMode NetworkOperationMode;



@protocol NetworkOperationDelegate <NSObject>
@optional
- (void)networkOprationDidComplete:(NSData*)responseData WithDict: (NSDictionary*) responseDict WithRef: (NSString*) operationRef;
@end



@interface NetworkOperation : NSOperation

@property (nonatomic, strong) NSDictionary *requestParam;
@property (nonatomic, assign) NetworkOperationMode requestMode;
@property (nonatomic, strong) NSString *requestServiceString;
@property (nonatomic, strong) NSString *operationRef;
@property (weak, nonatomic) id<NetworkOperationDelegate> delegate;

- (void) cancelNetworkOperation;

@end
