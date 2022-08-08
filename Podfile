# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# Networking
def setupNetworking
  pod 'Moya', '15.0'
end

# Log
def setupLog
  pod 'GoLog', '0.0.3'
end

# realmSetup
def setupRealm
  pod 'RealmSwift', '10.28.1'
end

# firebase SDK
def firebaseSetup
  pod 'Firebase'
  pod 'FirebaseCrashlytics'
end

def setup(key)
  if key == 'isFireBaseSetup'
    firebaseSetup
  end
  
  if key == 'isLogSetup'
    setupLog
    end
  
  if key == 'isNetworkSetup'
    setupNetworking
  end
  
  if key = 'isSetupRealm'
    setupRealm
  end
end

def getSettingByDev

  def isSetup(obj)
    obj.match('true')
  end

  keySave = ''
  f = File.open("iOS-Architecture-MVVMC/Resources/ConfigSettingSDK.plist")
  f.each_line do |line|
    if line.match('isFireBaseSetup')
      keySave = 'isFireBaseSetup'
    end
    
    if line.match('isLogSetup')
      keySave = 'isLogSetup'
    end
    
    if line.match('isNetworkSetup')
        keySave = 'isNetworkSetup'
    end
    
    if line.match('isSetupRealm')
      keySave = 'isSetupRealm'
    end
    
    if line.match('true') or line.match('false')
      if isSetup(line)
        setup(keySave)
      end
    end
    
  end
end

target 'iOS-Architecture-MVVMC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  getSettingByDev
  
  pod 'Kingfisher', '7.1.2'
  pod 'Reusable', '4.1.2'
  pod 'IQKeyboardManagerSwift', '6.5.10'

  # Pods for iOS-Architecture-MVVMC

  target 'iOS-Architecture-MVVMCTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iOS-Architecture-MVVMCUITests' do
    # Pods for testing
  end
end
