//
//  DOPAssetsCollectionViewController.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/13.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DOPAssetsCollectionViewController.h"
#import "DOPAssetsCollectionViewHeader.h"
#import "DOPAssetsCollectionViewCell.h"
#import "DOPImagePosterViewController.h"

@interface DOPAssetsCollectionViewController () <UICollectionViewDelegateFlowLayout,
                                                DOPAssetsCollectionHeaderDelegate,
                                                DOPImagePosterViewControllerDelegate>

@property (nonatomic,strong) ALAssetsLibrary* library;
@property (nonatomic,strong) NSMutableArray *assets;
@property (nonatomic,strong) NSMutableArray *selectedAssetUrls;

@end

@implementation DOPAssetsCollectionViewController

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.allowsMultipleSelection = YES;
        
        self.selectedAssetUrls = [[NSMutableArray alloc]init];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[DOPAssetsCollectionViewCell class]
            forCellWithReuseIdentifier:@"DOPAccetsCollectionViewCell"];
    [self.collectionView registerClass:[DOPAssetsCollectionViewHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"DOPAccetsCollectionViewHeader"];
    [self readAssets];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DOPAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DOPAccetsCollectionViewCell" forIndexPath:indexPath];
    
    cell.showsOverlayViewWhenSelected = YES;
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    cell.asset = asset;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ( kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          withReuseIdentifier:@"DOPAccetsCollectionViewHeader"
                                                                 forIndexPath:indexPath];
        DOPAssetsCollectionViewHeader *header = (DOPAssetsCollectionViewHeader *) reusableview;
        [header setDelegate:self];
    }
    NSLog(@"kind %@, cell %@", kind, reusableview);
    
    return reusableview;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    
    NSString *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    [self.selectedAssetUrls addObject: assetURL];
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    NSString *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    [self.selectedAssetUrls removeObject:assetURL];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(102, 102);
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - DOPAssetsCollection Header delegate

- (void) selectionDone {
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithCapacity:1];
    [data setObject:self.selectedAssetUrls forKey:DOP_ASSETS_LIBRARY_SELECTED_DATA_KEY_FOR_PHOTOURLS];
    DOPImagePosterViewController *poster = [[DOPImagePosterViewController alloc] initWithData:data];
    poster.delegate = self;
    
    [self presentViewController:poster animated:YES completion:Nil];
    
}

- (void) selectionCanceled {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - DOPImagePosterViewController delegate

- (void) didDismissViewWith:(NSDictionary *) data
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate didDismissViewWith:data];
    }];
}

#pragma mark - privates
- (void) readAssets
{
    self.library = [[ALAssetsLibrary alloc] init];
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    __weak typeof(self) weakSelf = self;
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        NSLog(@"in block");
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSInteger cnt = group.numberOfAssets;
        NSLog(@"number of assets:%ld",(long) cnt);
        if (cnt > 0) {
            weakSelf.assets = [[NSMutableArray alloc] initWithCapacity:cnt];
            for (NSInteger idx = 0; idx < cnt; idx++) {
                [weakSelf.assets addObject:[NSNull null]];
            }
            
            __block NSInteger idx = cnt;
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result) {
                    [weakSelf.assets replaceObjectAtIndex:--idx withObject:result];
                }
            }];
            *stop = YES;
            NSLog(@"get assets number:%ld",(long)[weakSelf.assets count] );
            NSLog(@"get assets:%@",group );
            [weakSelf.collectionView reloadData];
            
        }
        
        
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
    }];
}
@end
