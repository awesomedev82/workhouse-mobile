import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'npm:@supabase/supabase-js'
import { JWT } from 'npm:google-auth-library'

interface Announcement {
  id: any
  created_at: any
  sender: any
  description: any
  images: any
  community_id: any
  hide: any
}

interface WebhookPayload {
  type: 'INSERT'
  table: string
  record: Announcement
  schema: 'public'
  old_record: null | Announcement
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json()

  const { default: serviceAccount } = await import('../service-account.json', {
    with: { type: 'json' },
  })

  const accessToken = await getAccessToken({ clientEmail: serviceAccount.client_email, privateKey: serviceAccount.private_key, });

  const tokenDatas = await supabase.from('member_fcm_tokens').select('token')

  if (tokenDatas.error) {
    throw tokenDatas.error
  }

  const promises = tokenDatas.data.map(async (tokenData: { token: string }) => {
    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: tokenData.token,
            notification: {
              title: 'New Announcement',
              body: 'A new announcement was posted recently!',
            }
          }
        })
      }
    )
    
    const resData = await res.json()
    if (res.status < 200 || res.status > 299) {
      console.error(`Error sending notification to token ${tokenData.token}:`, resData)
    }
    return resData
  })

  const results = await Promise.all(promises)
  console.log("All notifications sent:", results)

  return new Response(
    JSON.stringify(tokenDatas.data),
    { headers: { "Content-Type": "application/json" } },
  )
})

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err)
        return;
      }
      resolve(tokens!.access_token!)
    })
  })
}
