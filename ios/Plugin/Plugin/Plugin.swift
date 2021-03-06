import Foundation
import Capacitor
import Photos

@objc(GetLatestPhoto)
public class GetLatestPhoto: CAPPlugin {
    
    @objc func getLastPhotoTaken(_ call: CAPPluginCall) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if(fetchResult.count > 0){
            
            let image = getAssetThumbnail(asset: fetchResult.object(at: 0))
            let imageData:Data =  UIImagePNGRepresentation(image)!
            let base64String = imageData.base64EncodedString()
            
            call.success([
                "image": base64String
                ])
            
        } else {
            
            call.error("Could not get photo")
            
        }
        
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
    
}
