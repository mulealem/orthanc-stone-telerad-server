function OnStoredInstance(instanceId, tags, metadata, origin)
    -- Prepare payload with instance details
    local payload = {
        instanceId = instanceId,
        patientId = tags["PatientID"],
        studyInstanceUID = tags["StudyInstanceUID"],
        seriesInstanceUID = tags["SeriesInstanceUID"],
        sopInstanceUID = tags["SOPInstanceUID"],
        event = "NewInstanceUploaded"
    }

    -- Convert payload to JSON
    local jsonPayload = DumpJson(payload, true)

    -- Send HTTP POST to webhook
    local webhookUrl = "http://75.119.148.56:3019/echo"
    HttpPost(webhookUrl, jsonPayload, { ["Content-Type"] = "application/json" })
end