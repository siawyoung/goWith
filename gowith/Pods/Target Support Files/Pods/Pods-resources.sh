#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=""

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      XCASSET_FILES="$XCASSET_FILES '$1'"
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "DateTools/DateTools/DateTools.bundle"
  install_resource "GPUImage/framework/Resources/lookup.png"
  install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
  install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
  install_resource "JGProgressHUD/JGProgressHUD/JGProgressHUD/JGProgressHUD Resources.bundle"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_received.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_sent.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Controllers/JSQMessagesViewController.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellIncoming.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellOutgoing.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesLoadEarlierHeaderView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesToolbarContentView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesTypingIndicatorFooterView.xib"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "DateTools/DateTools/DateTools.bundle"
  install_resource "GPUImage/framework/Resources/lookup.png"
  install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
  install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
  install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
  install_resource "JGProgressHUD/JGProgressHUD/JGProgressHUD/JGProgressHUD Resources.bundle"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_received.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_sent.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Controllers/JSQMessagesViewController.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellIncoming.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellOutgoing.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesLoadEarlierHeaderView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesToolbarContentView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesTypingIndicatorFooterView.xib"
fi

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n $XCASSET_FILES ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac
  echo $XCASSET_FILES | xargs actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
