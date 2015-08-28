
package fluidity.utils;

class AdMob
{

    public static var leaveAppCallback:Void->Void = function(){};
    public static var appBlockedCallback:Void->Void = function(){};

    public static inline function init()
    {
        #if android
        extension.admob.AdMob.init();
        #end
    }

    public static inline function cacheInterstitial(interstitialId:String)
    {
        #if android
        extension.admob.AdMob.cacheInterstitial(interstitialId);
        #end
    }

    public static inline function showInterstitial(interstitialId:String)
    {
        #if android
        if(extension.admob.AdMob.hasCachedInterstitial(interstitialId)) {
        // Shows an interstitial with the given id.
        // If this is called and the ad isn't cached, then it won't display at all (that's just how the AdMob SDK works).
        // Generally you should cache interstitial ads well in advance of showing them.
        extension.admob.AdMob.showInterstitial(interstitialId);
        }
        #end
    }
}