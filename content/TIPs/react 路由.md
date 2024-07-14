```tsx
'use client'
import { Outlet, RouterProvider, createBrowserRouter } from 'react-router-dom'

import Mint from '@/src/app/Mint/index'
import CreateCollection from '@/src/app/CreateCollection'
import MyCollections from '@/src/app/MyCollections'
import User from './user/page'
import Home from './Home'
import { PetraWallet } from 'petra-plugin-wallet-adapter' // petra 钱包适配器插件
import React from 'react'
import Learning from './learning/page'

const wallets = [new PetraWallet()]

function Layout() {
  return (
    <>
      <Outlet />
    </>
  )
}

const router = createBrowserRouter([
  {
    element: <Layout />,
    children: [
      {
        path: '/',
        element: <Home />,
      },
      {
        path: 'nft',
        element: <Mint />,
      },
      {
        path: 'learning',
        element: <Learning />,
      },
      {
        path: 'about',
        element: <MyCollections />,
      },
      {
        path: 'user',
        element: <User />,
      },
    ],
  },
])

function App() {
  return (
    <>
      <React.StrictMode>
        <RouterProvider router={router} />
      </React.StrictMode>
    </>
  )
}

export default App

```