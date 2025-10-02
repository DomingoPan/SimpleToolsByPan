import os
import cv2
import imageio

# 設定資料夾路徑
input_folder = r"C:\Users\user\Desktop\果蠅爬行力影片\0109-20250113T024837Z-001\0109"  # 替換為您的影片資料夾路徑
output_folder = r"C:\Users\user\Desktop\果蠅爬行力影片\0109-20250113T024837Z-001\0109\input_images"  # 替換為儲存圖片的資料夾路徑
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

target_second = 18

for video_file in os.listdir(input_folder):
    if video_file.lower().endswith('.mpg'):
        video_path = os.path.join(input_folder, video_file)
        output_path = os.path.join(output_folder, f"{os.path.splitext(video_file)[0]}_frame_at_{target_second}s.jpg")

        # 嘗試用 OpenCV
        cap = cv2.VideoCapture(video_path)
        if cap.isOpened():
            fps = cap.get(cv2.CAP_PROP_FPS)
            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            target_msec = target_second * 1000

            if total_frames > 0:
                cap.set(cv2.CAP_PROP_POS_MSEC, target_msec)
                ret, frame = cap.read()
                if ret:
                    cv2.imwrite(output_path, frame)
                    print(f"成功提取: {output_path}")
                    cap.release()
                    continue
            cap.release()

        # 如果 OpenCV 無法處理，改用 imageio
        try:
            reader = imageio.get_reader(video_path, format='ffmpeg')
            fps = reader.get_meta_data()['fps']
            target_frame = int(target_second * fps)

            for i, frame in enumerate(reader):
                if i == target_frame:
                    imageio.imwrite(output_path, frame)
                    print(f"成功提取: {output_path}")
                    break
            reader.close()
        except Exception as e:
            print(f"處理失敗: {video_file}，錯誤: {e}")
