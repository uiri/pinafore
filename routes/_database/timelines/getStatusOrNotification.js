import { dbPromise, getDatabase } from '../databaseLifecycle'
import { getInCache, hasInCache, notificationsCache, setInCache, statusesCache } from '../cache'
import {
  ACCOUNTS_STORE,
  NOTIFICATIONS_STORE,
  STATUSES_STORE
} from '../constants'
import { fetchStatus } from './fetchStatus'
import { fetchNotification } from './fetchNotification'

export async function getStatus (instanceName, id) {
  if (hasInCache(statusesCache, instanceName, id)) {
    return getInCache(statusesCache, instanceName, id)
  }
  const db = await getDatabase(instanceName)
  let storeNames = [STATUSES_STORE, ACCOUNTS_STORE]
  let result = await dbPromise(db, storeNames, 'readonly', (stores, callback) => {
    let [ statusesStore, accountsStore ] = stores
    fetchStatus(statusesStore, accountsStore, id, callback)
  })
  setInCache(statusesCache, instanceName, id, result)
  return result
}

export async function getNotification (instanceName, id) {
  if (hasInCache(notificationsCache, instanceName, id)) {
    return getInCache(notificationsCache, instanceName, id)
  }
  const db = await getDatabase(instanceName)
  let storeNames = [NOTIFICATIONS_STORE, STATUSES_STORE, ACCOUNTS_STORE]
  let result = await dbPromise(db, storeNames, 'readonly', (stores, callback) => {
    let [ notificationsStore, statusesStore, accountsStore ] = stores
    fetchNotification(notificationsStore, statusesStore, accountsStore, id, callback)
  })
  setInCache(notificationsCache, instanceName, id, result)
  return result
}
