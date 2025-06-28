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

    print(instanceId)
    print(tags["PatientID"])
    print(tags["StudyInstanceUID"])
    print(tags["SeriesInstanceUID"])
    print(tags["SOPInstanceUID"])

    print(DumpJson(payload, true))

    -- Convert payload to JSON
    local jsonPayload = DumpJson(payload, true)
    if not jsonPayload then
        print('Failed to convert payload to JSON')
        return
    end

    -- -- Log the payload for debugging
    -- PrintRecursive('Payload to send: ', jsonPayload)

    -- -- Send HTTP POST to webhook
    -- local webhookUrl = "https://webhook-service-iota.vercel.app/webhook"
    local webhookUrl = "http://75.119.148.56:3019/echo"
    print('Sending webhook to: ' .. webhookUrl)
    -- local response = HttpPost(webhookUrl, jsonPayload, {
    --     headers = { ["Content-Type"] = "application/json" },
    --     timeout = 10, -- Ensure timeout is a number
    --     verifyCertificate = false
    -- })
    local response = HttpPost(webhookUrl, jsonPayload, {
        ["Content-Type"] = "application/json",
    })

    -- Log the response
    if response then
        print("There it is")
    else
        print('Failed to send webhook')
    end
end