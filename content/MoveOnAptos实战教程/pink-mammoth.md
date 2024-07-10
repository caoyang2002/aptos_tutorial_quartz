```ts
'use client'
// 定义了钱包按钮的显示
import GoogleLogo from '@/src/static/GoogleLogo'
import useEphemeralKeyPair from '@/src/hooks/useEphemeralKeyPair'
import { useKeylessAccount } from '@/src/context/KeylessAccountContext'

// import { toast } from 'sonner'
import localFont from 'next/font/local'

const pixtext = localFont({
  src: './../../public/fonts/kongtext.ttf',
  variable: '--font-kongtext',
})

const buttonStyles =
  'nes-btn flex items-center justify-center md:gap-4 py-2 flex-nowrap whitespace-nowrap'

export default function WalletButtons() {
  if (!process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID) {
    throw new Error('Google Client ID is not set in env')
  }

  const { keylessAccount, setKeylessAccount } = useKeylessAccount()

  const ephemeralKeyPair = useEphemeralKeyPair()

  const redirectUrl = new URL('https://accounts.google.com/o/oauth2/v2/auth')
  const searchParams = new URLSearchParams({
    /**
     * Replace with your own client ID
     */
    client_id: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID,
    /**
     * The redirect_uri must be registered in the Google Developer Console. This callback page
     * parses the id_token from the URL fragment and combines it with the ephemeral key pair to
     * derive the keyless account.
     */
    // 重定向的 url
    redirect_uri:
      typeof window !== 'undefined'
        ? `${window.location.origin}/callback`
        : (process.env.NEXT_PUBLIC_VERCEL_ENV === 'development'
            ? 'http://localhost:3000'
            : process.env.NEXT_PUBLIC_VERCEL_URL) + '/callback',

    /**
     * This uses the OpenID Connect implicit flow to return an id_token. This is recommended
     * for SPAs (single-page applications) as it does not require a backend server.
     */
    response_type: 'id_token',
    scope: 'openid email profile',
    nonce: ephemeralKeyPair.nonce,
  })
  console.log('nonce: ', ephemeralKeyPair.nonce)
  redirectUrl.search = searchParams.toString()

  const disconnect = () => {
    setKeylessAccount(null)
    // toast.success('Successfully disconnected account')
  }

  // 如果有 address
  if (keylessAccount) {
    console.log('aptos address: ', keylessAccount.accountAddress.toString())
    // address string
    var addressStr = keylessAccount.accountAddress.toString()
    const preMaxLength = 4 // 你可以根据需要调整这个长度
    const shortAddressStr =
      addressStr.substring(0, preMaxLength) +
      '...' +
      addressStr.substring(addressStr.length - preMaxLength, addressStr.length)

    return (
      <div className="flex items-center justify-center m-auto sm:m-0 sm:px-4 ">
        <button
          className={buttonStyles}
          onClick={disconnect}
          title="Disconnect Wallet"
        >
          <GoogleLogo />
          <span
            title={keylessAccount.accountAddress.toString()}
            className={`${pixtext.className} text-xs text-white`}
          >
            {shortAddressStr}
          </span>
        </button>
      </div>
    )
  }

  // 如果没有 address
  return (
    <div className="flex items-center justify-center m-auto sm:m-0 sm:px-4">
      <a href={redirectUrl.toString()} className="hover:no-underline">
        <button className={buttonStyles}>
          <GoogleLogo />
          <span className={`${pixtext.className} text-xs text-white`}>
            Sign in with Google
          </span>
        </button>
      </a>
    </div>
  )
}

```