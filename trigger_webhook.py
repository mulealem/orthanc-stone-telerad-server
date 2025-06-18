import orthanc
import requests
import json

# Configuration
WEBHOOK_URL = 'https://your-webhook-url.com/webhook'  # Replace with your webhook URL

def send_webhook(data):
    """Send data to the webhook URL."""
    try:
        response = requests.post(WEBHOOK_URL, json=data, timeout=10)
        if response.status_code == 200:
            orthanc.LogWarning(f"Webhook sent successfully: {data}")
        else:
            orthanc.LogWarning(f"Failed to send webhook: {response.status_code} - {response.text}")
    except Exception as e:
        orthanc.LogWarning(f"Error sending webhook: {str(e)}")

def on_change(change_type, level, resource_id):
    """Handle Orthanc change events."""
    if change_type == orthanc.ChangeType.NEW_INSTANCE:
        try:
            # Get instance details
            instance_info = orthanc.RestApiGet(f'/instances/{resource_id}')
            instance_data = json.loads(instance_info)
            
            # Extract relevant DICOM tags
            tags = instance_data.get('MainDicomTags', {})
            patient_id = tags.get('PatientID', 'Unknown')
            patient_name = tags.get('PatientName', 'Unknown')
            study_instance_uid = tags.get('StudyInstanceUID', 'Unknown')
            
            # Construct URI for Orthanc Explorer
            orthanc_url = 'http://localhost:8042'  # Adjust to your Orthanc server URL
            instance_uri = f"{orthanc_url}/app/explorer.html#instance?uuid={resource_id}"
            
            # Prepare webhook payload
            payload = {
                'event': 'new_instance',
                'instance_id': resource_id,
                'patient_id': patient_id,
                'patient_name': patient_name,
                'study_instance_uid': study_instance_uid,
                'instance_uri': instance_uri,
                'timestamp': instance_data.get('LastUpdate', '')
            }
            
            # Send webhook
            send_webhook(payload)
            
            orthanc.LogWarning(f"New instance detected: {resource_id}")
        except Exception as e:
            orthanc.LogWarning(f"Error processing instance {resource_id}: {str(e)}")

# Register the callback
orthanc.RegisterOnChangeCallback(on_change)