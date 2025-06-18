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
    local webhookUrl = "https://webhook-service-iota.vercel.app/webhook"
    HttpPost(webhookUrl, jsonPayload, { ["Content-Type"] = "application/json" })
end